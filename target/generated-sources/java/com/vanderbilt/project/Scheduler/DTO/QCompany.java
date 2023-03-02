package com.vanderbilt.project.Scheduler.DTO;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QCompany is a Querydsl query type for Company
 */
@Generated("com.querydsl.codegen.EntitySerializer")
public class QCompany extends EntityPathBase<Company> {

    private static final long serialVersionUID = -909318142L;

    public static final QCompany company = new QCompany("company");

    public final NumberPath<Integer> companyId = createNumber("companyId", Integer.class);

    public final StringPath companyName = createString("companyName");

    public final StringPath companyScheduleJson = createString("companyScheduleJson");

    public final ListPath<Person, QPerson> personList = this.<Person, QPerson>createList("personList", Person.class, QPerson.class, PathInits.DIRECT2);

    public QCompany(String variable) {
        super(Company.class, forVariable(variable));
    }

    public QCompany(Path<? extends Company> path) {
        super(path.getType(), path.getMetadata());
    }

    public QCompany(PathMetadata metadata) {
        super(Company.class, metadata);
    }

}

